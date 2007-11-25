Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbXKYB0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbXKYB0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 20:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbXKYB0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 20:26:34 -0500
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:37366 "EHLO
	nlpi015.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbXKYB0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 20:26:33 -0500
X-ORBL: [209.233.25.226]
Message-ID: <4748CF46.1060507@pacbell.net>
Date: Sat, 24 Nov 2007 17:26:30 -0800
From: Dave Bailey <dsbailey@pacbell.net>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: Problem with ufs nextstep in 2.6.18 (debian)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes only symptom, not illness.
This check represent what code think about filesystem layout.
On what actually kind of UFS system did you test this patch?
When I sometime ago fixed similar issue for openstep ufs,
actully this was darwin's ufs which has the same layout,
I just set s_dirblksize to right value, may be for 
UFS_MOUNT_UFSTYPE_NEXTSTEP, UFS_MOUNT_UFSTYPE_NEXTSTEP_CD you need
do the same, see TODO items in fs/ufs/super.c.

-- 
/Evgeniy

Your right; I was using the NextStep ufstype on an OpenStep HD.
I have now checked an old (pre NS 3.3) floppy and a NS 3.3 CDROM
and they both need a  s_dirblksize  of 1024, just as the OpenStep
filesystem does. For the floppies, one can just use the OpenStep
option, but for a NextStep CDROM, the right s_dirblksize is
crucial. I would suggest changing both.

Thanks for the response,
