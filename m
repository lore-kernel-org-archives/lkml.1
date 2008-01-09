Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYAICqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYAICqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYAICp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:45:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYAICp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:45:58 -0500
Date: Tue, 8 Jan 2008 21:45:26 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080108214526.75a49a9c@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0801081441090.4678@schroedinger.engr.sgi.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
	<Pine.LNX.4.64.0801081421530.4281@schroedinger.engr.sgi.com>
	<20080108173634.5ed3b0d4@bree.surriel.com>
	<Pine.LNX.4.64.0801081441090.4678@schroedinger.engr.sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 14:42:03 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:
> On Tue, 8 Jan 2008, Rik van Riel wrote:
> 
> > > Also would it be possible to create generic functions that can move pages 
> > > in pagevecs to an arbitrary lru list?
> > 
> > What would you use those functions for?
> 
> We keep on duplicating the pagevec lru operation functions in mm/swap.c. 
> Some generic stuff would reduce the code size.

Good idea.  Added to my TODO list :)

-- 
All rights reversed.
