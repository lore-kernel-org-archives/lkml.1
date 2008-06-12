Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbYFLWiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbYFLWiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYFLWiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:38:11 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:33064 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759195AbYFLWiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:38:10 -0400
Date: Fri, 13 Jun 2008 00:38:03 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, cluster-devel@redhat.com,
       teigland@redhat.com
Subject: Re: [RFC] configfs: Allow ->make_item() and ->make_group() to
	return detailed errors.
Message-ID: <20080612223803.GB4012@localdomain>
Reply-To: Louis.Rilling@kerlabs.com
References: <1213305595-16805-1-git-send-email-joel.becker@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1213305595-16805-1-git-send-email-joel.becker@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 02:19:55PM -0700, Joel Becker wrote:
> The configfs operations ->make_item() and ->make_group() currently
> return a new item/group.  A return of NULL signifies an error.  Because
> of this, -ENOMEM is the only return code bubbled up the stack.
> 
> Multiple folks have requested the ability to return specific error codes
> when these operations fail.  This patch adds that ability by changing the
> ->make_item/group() ops to return an int.
> 
> Also updated are the in-kernel users of configfs.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>

Looks good to me. Happy to see this change coming :)

Louis

-- 
Dr Louis Rilling			Kerlabs - IRISA
Skype: louis.rilling			Campus Universitaire de Beaulieu
Phone: (+33|0) 2 99 84 71 52		Avenue du General Leclerc
Fax: (+33|0) 2 99 84 71 71		35042 Rennes CEDEX - France
http://www.kerlabs.com/
