Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbXCHRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbXCHRRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbXCHRRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:17:41 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58161 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbXCHRRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:17:40 -0500
Date: Thu, 8 Mar 2007 09:17:52 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 1/6] integrity: new hooks
Message-ID: <20070308171752.GN6602@sequoia.sous-sol.org>
References: <1173369800.5981.1.camel@localhost.localdomain> <20070308163118.GK6602@sequoia.sous-sol.org> <20070308170001.GA17304@sergelap.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070308170001.GA17304@sergelap.austin.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serue@us.ibm.com) wrote:
> It's unfortunate, agreed, but
> use of LSM as an integrity framework was also a no-go.
> 
> Options?

There's too much dup because stuff like above is just access control
not integrity measurement.  Need to break off the parts that really
are different.  But I don't have a great option offhand, I recognize
the complication.

thanks,
-chris
