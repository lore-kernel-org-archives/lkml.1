Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZEQJEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZEQJEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 05:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZEQJEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 05:04:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:19030 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbZEQJEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 05:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A9X9XHcU/Bnbu/0tRVkuS5O6hAxaUBUkokMgZRO9ahcFDXIxo3x0FymvXdRdPfpefA
         oFQ62toDDVDOVxN1g5a/tV5ccdiPsL80NUf/HEq02SLnjiuVy4DeV1M2qYFUV+RXt1vD
         MhGG/Y8W/EkigIMd1w3jFZWTb3G3opl/FIzro=
MIME-Version: 1.0
In-Reply-To: <4A0FD0AD.4030402@gmail.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
	 <5bdc1c8b0905151012x51c19b5cv639cadab1cee3849@mail.gmail.com>
	 <93655eb70905151024o634f8432j6c3db85df1f6ddfc@mail.gmail.com>
	 <5bdc1c8b0905151120p5aa58318t1765544fbbb695b2@mail.gmail.com>
	 <93655eb70905151938y558bf86flcfb7c6b6b2c171c6@mail.gmail.com>
	 <5bdc1c8b0905151947j326d31d9k5c7b1074af2b0bf0@mail.gmail.com>
	 <93655eb70905152012j2a40d2e0ta413a5e9dee34d46@mail.gmail.com>
	 <5bdc1c8b0905152037r614eaf8ft222c7a6294f2e80f@mail.gmail.com>
	 <93655eb70905152352n6f82ef9dubb9b36e5be161ac7@mail.gmail.com>
	 <4A0FD0AD.4030402@gmail.com>
Date: Sun, 17 May 2009 14:34:23 +0530
Message-ID: <93655eb70905170204k3b39b090u3413b8d00d225ca6@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
From: Satish Eerpini <eerpini@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Mark Knecht <markknecht@gmail.com>, Rik van Riel <riel@redhat.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> High iowait during a file copy with no other activity is entirely normal. If
> you have a core that has nothing to do but wait for IO to complete, you'll
> get iowait time. This isn't indicating a problem.

then the responsiveness seemed to be better with Wu Fengguang's
patches applied, or when I decreased the swappiness by decreasing the
value in /proc/sys/vm/swappiness . So I think I will stick with that,
and thanks everyone for the help.


thanks
Satish
-- 
http://satish.playdrupal.com
