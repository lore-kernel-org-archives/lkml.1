Return-Path: <linux-kernel-owner+w=401wt.eu-S932361AbYCGVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbYCGVEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764108AbYCGVEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:04:23 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:52614 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763827AbYCGVEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:04:22 -0500
Date: Fri, 07 Mar 2008 22:04:20 +0100
Message-Id: <187865500@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: ingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19VJty50JRVb/lWRQ13vnmiIeDkYk8LqX7/ubFW1SotnYKvK
 FrK/SOCrNOnXQIVx2gwUWm3eh+xcKPAezb/hOjy3O3rSp9TWkA=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> It's useless because it's exactly and trivially replaceable with:
>>
>>       init=/path/to/any/sbin/chroot /newroot /sbin/init
>
>ok, i didnt realize that this was possible. Ah ... i see, 
>init/main.c:init_setup() is special and picks the whole boot parameter 
>string up to the end, right? So init= is the only multi-parameter 
>init-parameter.
>
>        Ingo

wouldn`t it be useful to add a hint to kernel-parameters.txt ?


for now it just reads:

        init=           [KNL]
                        Format: <full_path>
                        Run specified binary instead of /sbin/init as init
                        process.

so, if there is no hint about that specialty (i.e. passing params to init, using for chroot etc..), no user will ever now.....

roland
_____________________________________________________________________
Unbegrenzter Speicherplatz für Ihr E-Mail Postfach? Jetzt aktivieren!
http://freemail.web.de/club/landingpage.htm/?mc=025555

