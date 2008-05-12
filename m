Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYELHiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYELHiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYELHiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:38:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:13715 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbYELHiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OuXnXyVP+xv2Jy0fLjDiMX10kliW8LP8JmuVjT9oAkSSOifyUuOEKd9C1xUYpP3+CeNYmII7yD8bvV/uDODl+5CzcjX2xg9PikAq8cN3aYdUb3q4AJf9eAkuaAVywntIgdqKoXFuUNslehDgCCSOFNfcafsgfOojhJ4OwKuazR4=
Message-ID: <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
Date: Mon, 12 May 2008 16:38:08 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Cc: "Andi Kleen" <andi@firstfloor.org>, "Christoph Lameter" <clameter@sgi.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Mel Gorman" <mel@skynet.ie>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, mpm@selenic.com
In-Reply-To: <20080510221515.3540a6cc@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080510030831.796641881@sgi.com>
	 <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org>
	 <20080510221515.3540a6cc@bree.surriel.com>
X-Google-Sender-Auth: 512e5085f74dab50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> What about the TPC performance regressions? My understanding was that
>> slub still performed worse in the "object allocated on one CPU, freed on
>> the other CPU" type workloads due to less batching.
>
> Which can be the majority of object allocations and frees in some
> workloads.  It definately wants fixing.

Agreed, that situation is very frequency happend, IMHO.
