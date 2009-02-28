Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZB1IL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZB1IL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZB1ILM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:11:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbZB1ILK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:11:10 -0500
Message-ID: <49A8F0D0.3070201@zytor.com>
Date: Sat, 28 Feb 2009 00:07:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: does boot loader check uncompressed kernel size?
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu> <49A8EA1A.50802@kernel.org>
In-Reply-To: <49A8EA1A.50802@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> wonder if boot loader check uncompress size aka vmlinux size in bzImage
> before it find one good position for bzImage...?

Most boot loaders load the bzImage to a single standard address, 0x100000.

	-hpa
