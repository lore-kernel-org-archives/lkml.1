Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZJ0Qhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZJ0Qhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbZJ0Qhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:37:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:50245 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbZJ0Qhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rsIeSEknwyOx+wQ5PT9TiUzZMKkJtHky5ebEfZwhZRpUQiZoxdrx1VCj0/kpokk4Ui
         5cwnk8n1qVJDlgEW8F6tb/tmuK7b24JZFrtmcSRWQpgSP7DINUS8CEUcFVm5dvEF/ik3
         MowN2Pe9P7HOeoghL6CBI6hZhyoEM8kObOHNQ=
Date: Tue, 27 Oct 2009 17:37:31 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Theodore Tso <tytso@mit.edu>, "Carlos R. Mafra" <crmafra2@gmail.com>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Keith Packard <keithp@keithp.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with
 T400 laptops
Message-ID: <20091027163731.GA32312@localhost>
References: <20091012120510.16bd1194@jbarnes-g45>
 <20091013023146.GA8414@mit.edu>
 <20091013100135.2b3d914f@jbarnes-g45>
 <20091013190055.GI8175@mit.edu>
 <20091013121426.35f409ff@jbarnes-g45>
 <20091014142252.009d03a5@jbarnes-g45>
 <20091015022645.GA8286@mit.edu>
 <20091015040204.GE8286@mit.edu>
 <20091019100437.22b6ea36@jbarnes-x200>
 <20091019101526.5496d5ed@jbarnes-x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019101526.5496d5ed@jbarnes-x200>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 10:15:26AM +0900, Jesse Barnes wrote:
> Here's an even more "final" patchset with some spurious hunks removed.

These patches solve the problems with severe screen flickering I
experienced on a "Mobile 4 Series Chipset" (rev07) and bisected down
to the "drm/i915: framebuffer compression for GM45+" commit
(74dff282237).

The flickering was most easily triggered by closing and opening the lid,
and was reduced or temporarily stopped by moving the mouse or pressing a
key.

Tested-by: Johan Hovold <jhovold@gmail.com>

Thanks,
Johan

