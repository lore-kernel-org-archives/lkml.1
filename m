Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbZHROPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbZHROPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZHROPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:15:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37626 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbZHROPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:15:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090814133225.GB27905@us.ibm.com>
References: <20090814133225.GB27905@us.ibm.com> <2359eed20908132115t2f6cea3by2429d54914d5ac6f@mail.gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, Will Drewry <redpig@dataspill.org>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org, morgan@kernel.org
Subject: Re: [RFC][PATCH 1/1] support optional non-VFS capability inheritance without disabling file caps
Date: Tue, 18 Aug 2009 15:07:12 +0100
Message-ID: <27938.1250604432@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> Heck, maybe we can use the fscache or a stackable fs to provide a view
> of a non-xattr fs with xattrs layered on top.  David Howells, does
> that sound doable or would that be an abuse?

You could use fscache, but you would have to deal with the cache not being
available or suddenly going away.  Note that fscache does not stack on top of
another fs in Linux in the way it does in Solaris - the non-xattr fs would
have to actively talk to fscache.  But it's certainly possible.

David
