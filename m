Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZFWLf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZFWLf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZFWLfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:35:21 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:61820 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZFWLfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:35:20 -0400
MIME-Version: 1.0
In-Reply-To: <4A3F7440.3030603@ahsoftware.de>
References: <4A38F229.70504@ahsoftware.de> <4A3AE162.7040407@gmail.com> 
	<ac3eb2510906201220v7fc1d51ve4a9937a3d73d3d4@mail.gmail.com> 
	<4A3F7440.3030603@ahsoftware.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 23 Jun 2009 13:35:07 +0200
Message-ID: <ac3eb2510906230435r6489ddafqb15214f190d4eae8@mail.gmail.com>
Subject: Re: asynchronous calls an the lack of --wait-for-completion options 
	(e.g. modprobe, losetup, cryptsetup)
To: Alexander Holler <holler@ahsoftware.de>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 14:08, Alexander Holler<holler@ahsoftware.de> wrote:
> On 20.06.2009 21:20, Kay Sievers wrote:

> Anyway, I still think, that the creation of the device-node is (seen from a
> user-point) part of the module-initialization or part of the operation of
> the userland-tool (like modprobe, losetup or cryptsetup). So in my point of
> view, they should at least offer an option to wait until udev finished that
> operation and should not rely on the user to call udevadm.

That would be all solved properly by "devtmpfs":
   http://lkml.org/lkml/2009/4/30/182

You might want to talk to the people who are delaying its adoption.

Thanks,
Kay
