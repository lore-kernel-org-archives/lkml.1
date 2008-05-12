Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYELPWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYELPWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 11:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYELPWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 11:22:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbYELPWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 11:22:06 -0400
Date: Mon, 12 May 2008 10:21:29 -0500
From: David Teigland <teigland@redhat.com>
To: Leonardo Potenza <lpotenza@inwind.it>
Cc: kernel-janitors@vger.kernel.org, ccaulfie@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/dlm: section mismatch warning fix
Message-ID: <20080512152129.GB31873@redhat.com>
References: <200805111915.34911.lpotenza@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805111915.34911.lpotenza@inwind.it>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 07:15:34PM +0200, Leonardo Potenza wrote:
> From: Leonardo Potenza <lpotenza@inwind.it>
> 
> Removed the section mismatch message:
> WARNING: fs/dlm/dlm.o(.init.text+0x132): Section mismatch in reference from the function init_module() to the function .exit.text:dlm_netlink_exit()
> 
> Since dlm_netlink_exit() is called in the init_dlm() error handling,
> the __exit annotation has been removed.
> 
> Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>

Thanks, I've added this to dlm.git.

Dave

