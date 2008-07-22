Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYGVAH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYGVAH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYGVAHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:07:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:55151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbYGVAHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:07:13 -0400
Date: Mon, 21 Jul 2008 17:07:12 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Julia Lawall <julia@diku.dk>, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/7] fs/ocfs2/file.c: Release mutex in error handling code
Message-ID: <20080722000711.GT28014@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <Pine.LNX.4.64.0807210958570.24625@ask.diku.dk> <20080721203608.GB31671@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721203608.GB31671@ca-server1.us.oracle.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 01:36:08PM -0700, Joel Becker wrote:
> On Mon, Jul 21, 2008 at 09:59:15AM +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > The mutex is released on a successful return, so it would seem that it
> > should be released on an error return as well.
> 
> 	This patch looks right to me.  Mark?

Yeah, that looks good. Thanks Julia.
	--Mark

--
Mark Fasheh
