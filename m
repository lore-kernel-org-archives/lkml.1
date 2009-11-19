Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbZKSLJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbZKSLJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 06:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZKSLJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 06:09:41 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:59589 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZKSLJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 06:09:40 -0500
MIME-Version: 1.0
In-Reply-To: <20091118213355.GA16630@srcf.ucam.org>
References: <ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com> 
	<20091117185742.GA19829@srcf.ucam.org> <ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com> 
	<20091118194053.GB12944@srcf.ucam.org> <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> 
	<20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> 
	<20091118200712.GA14026@srcf.ucam.org> <ac3eb2510911181306g221e8940xfbcf8b8e7fa9a56e@mail.gmail.com> 
	<20091118213355.GA16630@srcf.ucam.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 19 Nov 2009 12:09:30 +0100
Message-ID: <ac3eb2510911190309y6d0d8445wd907fc5664595c6f@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle 
	changes
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 22:33, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Nov 18, 2009 at 10:06:33PM +0100, Kay Sievers wrote:
>
>> That's true, but I think there is a significant difference between
>> polling every one or two seconds for media changes, and usually one or
>> two minutes for a disk idle. It's not that we poll in a rather hight
>> frequency, in an arbitrary interval, and check if some condition is
>> met.
>
> My use cases are on the order of a second.

Ok, what's the specific use case, which should be triggered after a
second? I thought you were thinking about disk spindown or similar.

Kay
