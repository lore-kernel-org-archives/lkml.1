Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYJVQyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYJVQyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYJVQx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:53:59 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:17590 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYJVQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dBckr/xJUrCbOjKvHifQhH3yUzXPT4Hop4oCsnowYhqHWmVH6tcp/kgrDx/axNisN8
         yq76x/3nnZuCGmAK937vkLGRkz4cyT/erZhqmbbK4TQJJh/emEz9KYq4z00Rgq4/bt5q
         AZ+XpSLX+RQHrSmwkLxnDQZDGEpaEht2ztKg8=
Date: Wed, 22 Oct 2008 20:53:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLUB - define OO_ macro instead of hardcoded numbers
Message-ID: <20081022165354.GI9639@localhost>
References: <20081022161836.GG9639@localhost> <Pine.LNX.4.64.0810220926130.7633@quilx.com> <20081022163530.GH9639@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022163530.GH9639@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Wed, Oct 22, 2008 at 08:35:30PM +0400]
| [Christoph Lameter - Wed, Oct 22, 2008 at 09:28:14AM -0700]
| > On Wed, 22 Oct 2008, Cyrill Gorcunov wrote:
| >
| >> Please check -- wouldn't it be better to use such a macro?
| >
| > Looks good. But could you rename OO_MAX to something different? There is  
| > already s->max which may cause confusion because s->max is the maximum  
| > number of objects in a slab. OO_MAX is the maximum mask?
| >
| 
| I supposed it would mean maximum object number inside page (ie quantity) which
| is happen to be the same value as OO_MASK. Maybe OO_MAX_OBJ?
| 
| 		- Cyrill -

Btw Christoph fix me if I'm wrong but this 65535 is directly related to
16 bit shift. If we change the first value without changing the second we
just break the SLUB I guess. I didn't read/understand SLUB code in details
so could be wrong.

		- Cyrill -
