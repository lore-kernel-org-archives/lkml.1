Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbYBSTrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbYBSTrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759161AbYBSTrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:47:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757665AbYBSTra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:47:30 -0500
Date: Tue, 19 Feb 2008 13:47:23 -0600
From: David Teigland <teigland@redhat.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Patrick Caulfield <pcaulfie@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dlm: match signedness between dlm_config_info and cluster_set
Message-ID: <20080219194723.GB5411@redhat.com>
References: <1202950469.18204.35.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202950469.18204.35.camel@brick>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 04:54:29PM -0800, Harvey Harrison wrote:
> cluster_set is only called from the macro CLUSTER_ATTR which defines read/write
> access functions.  Make the signedness match to avoid sparse warnings every time
> CLUSTER_ATTR is used (lines 149-159) all of the form:
> 
> fs/dlm/config.c:149:1: warning: incorrect type in argument 3 (different signedness)
> fs/dlm/config.c:149:1:    expected unsigned int *info_field
> fs/dlm/config.c:149:1:    got int extern [toplevel] *<noident>
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Thanks, added to dlm.git.
Dave

