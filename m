Return-Path: <linux-kernel-owner+w=401wt.eu-S932990AbXJMSMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbXJMSMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762037AbXJMSMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:12:07 -0400
Received: from THUNK.ORG ([69.25.196.29]:55160 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761931AbXJMSMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:12:05 -0400
Date: Sat, 13 Oct 2007 14:11:37 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Howells <dhowells@redhat.com>
Cc: viro@ftp.linux.org.uk, kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/52] Introduce credential record
Message-ID: <20071013181137.GA9051@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
	kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
	linux-kernel@vger.kernel.org
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

   I'm going to ask a stupid question, and I probably missed something
in the 52 patches, but....  I see how the credential is used to do
access checks, but why does the credentials record need to passed all
the way into block allocator?  What is it used for there?

    	     	   	       	       	  - Ted
