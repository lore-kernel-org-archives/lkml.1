Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZFSAwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZFSAwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZFSAwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:52:36 -0400
Received: from mail-yx0-f192.google.com ([209.85.210.192]:47595 "EHLO
	mail-yx0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZFSAwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rcpFGrlMFNvU+wR/3xOG41iULCfYwKYy4/+DedkwQZtoiLUC/9/60/27QIX446Px04
         kt/9wkk5r98cr7kU5FvsyIhcUSZ1WolFCE1SNeP39mKUGkR4lnJG6JqyEOTHi2WwbDW6
         ENFcIoboPxfmFDS2h0dzzUt9wZHePpYhjP7IU=
Message-ID: <4A3AE162.7040407@gmail.com>
Date: Thu, 18 Jun 2009 18:52:50 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: asynchronous calls an the lack of --wait-for-completion options
 (e.g.   modprobe, losetup, cryptsetup)
References: <4A38F229.70504@ahsoftware.de>
In-Reply-To: <4A38F229.70504@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2009 07:39 AM, Alexander Holler wrote:
> Hello,
>
> during the last kernel versions I've got more and more problems with
> scripts which are calling modprobe, losetup or e.g. cryptsetup.
>
> The problem is that when I'm e.g. calling modprobe loop, loop might not
> has finished it's initialization, when modprobe returns.

It will have. Just that udev won't have received the events and created 
the device node yet. So the solution would likely be on the udev side..
