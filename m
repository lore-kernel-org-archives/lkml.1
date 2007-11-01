Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbXKAOev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbXKAOev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761255AbXKAOe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:34:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760215AbXKAOe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:34:26 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Tony Jones <tonyj@suse.de>
Subject: Re: [PATCH] audit: clear thread flag for new children
Date: Thu, 1 Nov 2007 10:33:52 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       viro@ftp.linux.org.uk
References: <20071026204228.GA1519@suse.de> <200710291804.31784.sgrubb@redhat.com> <20071029231529.GB15210@suse.de>
In-Reply-To: <20071029231529.GB15210@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711011033.53265.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2007 07:15:30 pm Tony Jones wrote:
> On Mon, Oct 29, 2007 at 06:04:31PM -0400, Steve Grubb wrote:
> > So when audit is re-enabled, how do you make that task auditable?
>
> No idea. How do you do it currently? HINT: current->audit_context == NULL
> for these tasks.  If !audit_enabled, then audit_alloc() is not going to
> allocate an audit_context for the task.

We are looking into this - at one time it did. Someone should follow up with a 
path correcting this soon. But I doubt the audit system will work correctly 
if the flag gets removed as there is no good way to add it again later.

-Steve
