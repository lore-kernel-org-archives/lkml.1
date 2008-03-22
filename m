Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYCVEij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYCVEij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 00:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYCVEic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 00:38:32 -0400
Received: from hs-out-0708.google.com ([64.233.178.245]:4606 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYCVEic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 00:38:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K2jiwROyPGaZuMEsckbqdk/gSfu/1LG4/1F9b1xPDJX7ewXDi+arIPxIfWC4x4h7Dq41VFM6GSymVR/6qxI4dsv9wHv5POwvgf8MjLVIudCar99/wqo68NTpZT9vPOTiexCNMp8kh/IfG//OGgU2MA+QGyq8m6aDa6ED8h0eD2U=
Message-ID: <a36005b50803212138m1c37dd9evcecb0ebda569670c@mail.gmail.com>
Date: Fri, 21 Mar 2008 21:38:29 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080321172644.GG2346@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318003620.d84efb95.akpm@linux-foundation.org>
	 <20080318095715.27120788.akpm@linux-foundation.org>
	 <20080318172045.GI11966@one.firstfloor.org>
	 <20080318104437.966c10ec.akpm@linux-foundation.org>
	 <20080319083228.GM11966@one.firstfloor.org>
	 <20080319020440.80379d50.akpm@linux-foundation.org>
	 <a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com>
	 <20080320090005.GA25734@one.firstfloor.org>
	 <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com>
	 <20080321172644.GG2346@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 10:26 AM, Andi Kleen <andi@firstfloor.org> wrote:
>  When would that time be? I cannot think of a single heuristic that would
>  work for both "/bin/true" and a OpenOffice start.

In both cases the stable state is reached after, say, 4 seconds.  It's
just that true terminates before the time is up.  I think something
like "trace the first N seconds" is a reasonable heuristics.
