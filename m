Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015Ab0AZWB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0AZWB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847Ab0AZWBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:01:25 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:50337 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab0AZWBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:01:25 -0500
Subject: Re: [RFC PATCH 1/2] Fix 1 untangling ima mess, part 2 with counters
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       "Serge E. Hallyn" <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20100126130349.GH19799@ZenIV.linux.org.uk>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
	 <4ad974923eae7a8f52be0786a630b6c64bee9d32.1264018123.git.zohar@linux.vnet.ibm.com>
	 <20100123230735.GW19799@ZenIV.linux.org.uk>
	 <1264447477.3696.30.camel@dyn9002018117.watson.ibm.com>
	 <20100126130349.GH19799@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 26 Jan 2010 17:01:01 -0500
Message-Id: <1264543261.3556.1.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 13:03 +0000, Al Viro wrote: 
> OK, this stuff is in for-next, with the following changes:
> 	* nfsd call has been moved to nfsd_open()
> 	* patches reordered
> 	* masking irrelevant bits (i.e. leaving only MAY_{READ,WRITE,EXEC})
> has been taken to ima_path_check(); all callers do it and it's safer that
> way anyway.
> 
> Please, see if it's OK with you in this form; other calls of dentry_open()
> are separate story, we'll have to see which ones should and which ones
> should not get ima_path_check().  Do you have any other problems with that
> one?  If not, it's going to migrate into for-linus and into the mainline;
> this stuff is definitely 2.6.33 fodder.

Other than missing the export for ima_path_check() for nfs and the
re-ordering not being bisect safe, they look good.  I've updated
the following two patches, from Eric's patchset, and would appreciate
your applying them as well:

ima: rename ima_path_check to ima_file_check
ima: rename PATH_CHECK to FILE_CHECK

Posting them separately.

Mimi



