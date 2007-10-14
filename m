Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbXJNMaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbXJNMaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 08:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXJNMaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 08:30:09 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2417 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbXJNMaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 08:30:06 -0400
Message-ID: <47120BC9.2060008@xs4all.nl>
Date: Sun, 14 Oct 2007 14:30:01 +0200
From: Bauke Jan Douma <bjdouma@xs4all.nl>
Reply-To: bjdouma@xs4all.nl
Organization: a training zoo
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: vignesh babu <vigneshbabu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: wierd file perms
References: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com> <20071013172848.GE16774@lug-owl.de>
In-Reply-To: <20071013172848.GE16774@lug-owl.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Benedict Glaw wrote on 13-10-07 19:28:
> On Sat, 2007-10-13 22:40:23 +0530, vignesh babu <vigneshbabu@gmail.com> wrote:
>> I was surprised and did an ls -l on the files and guess what I found:
>>
>> total 0
>> ?--------- ? ? ? ?                ? fcntl.c
>> ?--------- ? ? ? ?                ? fifo.c
>> ?--------- ? ? ? ?                ? filesystems.c
>> ?--------- ? ? ? ?                ? file_table.c
>> ?--------- ? ? ? ?                ? freevxfs
>>
>> So end result is that, Im not able to delete the files or change perms
>> or ownership even as root.
> 
> Most probably, your filesystem is broken and needs a fsck.
> 
> MfG, JBG
> 

I don't think this is a bug, but a feature of 'ls', see for instance
the coreutils mailing list:

http://lists.gnu.org/archive/html/bug-coreutils/2007-05/msg00226.html

bjd

