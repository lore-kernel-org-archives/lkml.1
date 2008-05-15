Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYEOR0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYEOR0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYEOR01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:26:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56698 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751264AbYEOR00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:26:26 -0400
Date: Thu, 15 May 2008 10:26:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andy Whitcroft <apw@shadowen.org>
cc: linux-mm@kvack.org, Andrew Morton <akpm@osdl.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] explicitly document overloaded page flags
In-Reply-To: <exportbomb.1210871946@pinky>
Message-ID: <Pine.LNX.4.64.0805151026000.18354@schroedinger.engr.sgi.com>
References: <exportbomb.1210871946@pinky>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Andy Whitcroft wrote:

> With the recent page flag reorganisation we have a single enum which
> defines the valid page flags and their values, nice and clear.  However
> there are a number of bits which are overloaded by different subsystems.
> Firstly there is PG_owner_priv_1 which is used by filesystems and by XEN.
> Secondly both SLOB and SLUB use a couple of extra page bits to manage
> internal state for pages they own; both overlay other bits.  All of these
> "aliases" are scattered about the source making it very hard for a reader
> to know if the bits are safe to rely on in all contexts; confusion here
> is bad.
> 
> As we now have a single place where the bits are clearly assigned it makes
> sense to clarify the reuse of bits by making the aliases explicit and
> visible with the original bit assignments.  This patch creates explicit
> aliases within the enum itself for the overloaded bits and uses those
> aliases throughout.

Ahh. Great! I considered doing that work too but never got around to it.
