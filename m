Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYDQWKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYDQWKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 18:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYDQWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 18:10:04 -0400
Received: from sous-sol.org ([216.99.217.87]:55643 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbYDQWKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 18:10:03 -0400
Date: Thu, 17 Apr 2008 15:09:20 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, stable@kernel.org,
       Chuck Lever <chuck.lever@oracle.com>
Subject: Re: SUNRPC: Fix a memory leak in rpc_create()
Message-ID: <20080417220920.GH17220@sequoia.sous-sol.org>
References: <20080417010122.148289106@sous-sol.org> <20080417010354.950049854@sous-sol.org> <200804172325.39462.s.L-H@gmx.de> <1208469997.5375.4.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208469997.5375.4.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trond Myklebust (Trond.Myklebust@netapp.com) wrote:
> Gah. You're quite right. The commit that introduced the leak was merged
> well after 2.6.24 was released despite what the changelog entry says
> above:
> 
> $ git describe 510deb0d
> v2.6.24-3933-g510deb0
> 
> I should have double-checked before posting this to stable@kernel.org.
> I'm very sorry...

Thanks, I dropped it.
-chris
