Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbYAIXnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbYAIXnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYAIXnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:43:23 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:54942 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYAIXnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:43:22 -0500
Date: Thu, 10 Jan 2008 00:43:19 +0100
Message-Id: <95637914@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: agk@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] fast file mapping for loop
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/BKVpos+cEKh0qpzDH/SNcDa9mIcNRLwO7P6lmp7n731rTe
 cPVvatebffoarlEM9KsCevnsyHKuM6diTfhlymUvEKYgaCjYtU=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oh, nice to see that this is still alive.

i tried this around half a year ago because i needed more than 256 loop devices and iirc, this was working quite fine.
at least i got no crashes and was able to mount and acess more than 300 iso-images with that.

shortly after, loop device was extended to handle  a larger number of loop-devices and i went that way because dm-loop was not in mainline.

i have taken a look at the wiki at http://sources.redhat.com/lvm2/wiki/DMLoop from time to time, but there didn`t seem to happen much.

were there fixes/chances since then?

do you think it`s ready for mainline?



>Here's the latest version of dm-loop, for comparison.
>
>To try it out, 
>  ln -s dmsetup dmlosetup
>and supply similar basic parameters to losetup.
>(using dmsetup version 1.02.11 or higher)
>
>Alasdair
>
>From: Bryn Reeves <breeves@redhat.com>
>
>This implements a loopback target for device mapper allowing a regular
>file to be treated as a block device.
>
>Signed-off-by: Bryn Reeves <breeves@redhat.com>
>Signed-off-by: Alasdair G Kergon <agk@redhat.com>

__________________________________________________________________________
Erweitern Sie FreeMail zu einem noch leistungsstärkeren E-Mail-Postfach!		
Mehr Infos unter http://produkte.web.de/club/?mc=021131

