Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbYAGTIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbYAGTIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYAGTH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:07:56 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33522 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751761AbYAGTHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:07:55 -0500
Date: Mon, 7 Jan 2008 11:07:54 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Eric Whitney <eric.whitney@hp.com>, Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [patch 00/19] VM pageout scalability improvements
In-Reply-To: <1199466372.5290.37.camel@localhost>
Message-ID: <Pine.LNX.4.64.0801071107440.23617@schroedinger.engr.sgi.com>
References: <20080102224144.885671949@redhat.com>  <1199379128.5295.21.camel@localhost>
  <20080103120000.1768f220@cuia.boston.redhat.com>  <1199380412.5295.29.camel@localhost>
  <20080103170035.105d22c8@cuia.boston.redhat.com>  <1199463934.5290.20.camel@localhost>
  <p73d4sh8s93.fsf@bingen.suse.de> <1199466372.5290.37.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008, Lee Schermerhorn wrote:

> We see this on both NUMA and non-NUMA. x86_64 and ia64.  The basic
> criteria to reproduce is to be able to run thousands [or low 10s of
> thousands] of tasks, continually increasing the number until the system
> just goes into reclaim.  Instead of swapping, the system seems to
> hang--unresponsive from the console, but with "soft lockup" messages
> spitting out every few seconds...

Ditto here.

