Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZDDRve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZDDRve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 13:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZDDRvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 13:51:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:11585 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZDDRvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 13:51:23 -0400
MIME-Version: 1.0
In-Reply-To: <20090404152731.GA5080@srcf.ucam.org>
References: <20090401203726.GA17485@srcf.ucam.org> <20090403025654.GA20146@suse.de> 
	<20090403135719.GD19774@srcf.ucam.org> <20090403150301.GA25846@suse.de> 
	<20090403151237.GA25994@suse.de> <20090403164551.GA23689@srcf.ucam.org> 
	<20090404152731.GA5080@srcf.ucam.org>
Date: Sat, 4 Apr 2009 19:51:06 +0200
Message-ID: <ac3eb2510904041051k45599297s6a97094702664aac@mail.gmail.com>
Subject: Re: qcserial/gobi firmware loader
From: Kay Sievers <kay.sievers@vrfy.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, shurik@gwu.edu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 4, 2009 at 17:27, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> I've reimplemented Alexander's shell scripts for firmware loading in C
> and added a udev rule to automatically trigger the loading[1].

This misses a '=':
  GOTO "gobi_rules_end"

This:
  /dev/%k
should be:
  $env{DEVNAME}

Thanks,
Kay
