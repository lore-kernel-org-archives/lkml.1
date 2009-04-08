Return-Path: <linux-kernel-owner+w=401wt.eu-S934401AbZDHTqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401AbZDHTqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 15:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbZDHTpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 15:45:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60590 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959AbZDHTpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 15:45:42 -0400
Date: Wed, 8 Apr 2009 22:45:40 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Glauber Costa <glommer@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] disable interrupt shadow state for emulated instruction
Message-ID: <20090408194540.GD18521@redhat.com>
References: <1239213452-5966-1-git-send-email-glommer@redhat.com> <49DCE9E5.8020703@zytor.com> <20090408183110.GD25323@poweredge.glommer> <49DCED9A.8030108@zytor.com> <20090408184306.GE25323@poweredge.glommer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408184306.GE25323@poweredge.glommer>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 03:43:06PM -0300, Glauber Costa wrote:
> On Wed, Apr 08, 2009 at 11:31:54AM -0700, H. Peter Anvin wrote:
> > Glauber Costa wrote:
> >> mov ss is a non-issue, since it is executed natively.
> >
> > In real mode?
> it seems so, to me. But I can be wrong. If I am, then I'd
> propose the same path I proposed for sti for this.
> 
In big real mode everything is emulated.

--
			Gleb.
