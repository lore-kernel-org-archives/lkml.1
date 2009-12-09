Return-Path: <linux-kernel-owner+w=401wt.eu-S967078AbZLIBIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967078AbZLIBIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 20:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967057AbZLIBIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 20:08:35 -0500
Received: from RELAY-02.ANDREW.CMU.EDU ([128.2.10.85]:56279 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967049AbZLIBIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 20:08:35 -0500
Date: Tue, 8 Dec 2009 20:08:18 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com
Subject: Re: [RFC] [PATCH 5/5] cgroups: subsystem dependencies
Message-ID: <20091209010817.GA8929@andrew.cmu.edu>
References: <20091204085349.GA18867@andrew.cmu.edu> <20091204085854.GE18912@andrew.cmu.edu> <4B1DEE09.4010508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1DEE09.4010508@cn.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 02:11:21PM +0800, Li Zefan wrote:
> > This patch adds a mechanism with which a subsystem can specify dependencies on
> > other subsystems. Since subsystems can come and go, it would not be useful to
> > refer to a depended-upon subsystem by subsys_id, so instead a NULL-terminated
> > array of strings must be specified. Validation is done by scanning for each
> > potential subsystem its list of subsystem names with strcmp at the end of
> > parse_cgroupfs_options.
> 
> I once posted a patch to implement this feature, but it was
> rejected by Andrew, because there was no user using it.
> 
> And still there is no user, right?

Dunno - Paul mentioned it might be useful in the future, so I threw this
together in an hour or so. Not entirely sure what he had in mind, but
this series can go with or without this particular patch.
