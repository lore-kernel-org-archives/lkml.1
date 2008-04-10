Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYDJR6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYDJR6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758470AbYDJR6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:58:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35619 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758390AbYDJR6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:58:22 -0400
Date: Thu, 10 Apr 2008 12:56:41 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Leskovec <dlesko@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 1/1] user namespaces: add ns to user_struct (v3)
Message-ID: <20080410175641.GA9108@sergelap.ibm.com>
References: <20080402200840.GA437@sergelap.ibm.com> <20080404022751.GA9216@sergelap.austin.ibm.com> <47F66B4E.6080802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F66B4E.6080802@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Leskovec (dlesko@linux.vnet.ibm.com):
> Hi Serge,
> 
> Yep, this latest patch fixed the user namespace problem I was seeing.  Thanks!

Of course as discussed with Eric this should be solved with sysfs
remounts (and btw without breaking api which this patch does :( )
so please ignore this patch.

I will try to get a correct patch out next week.  I want to make
sure to do it in a way that meshes with the analogous netns code,
so it may take me a bit longer than i'd like.

thanks,
-serge
