Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbYCEKmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbYCEKmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758851AbYCEKl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:41:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:23734 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415AbYCEKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:41:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=IBZHsj5WKHdOACj/9SfaXbJg5P3NrMxM+4aFNO9taex3fCo1f+XjoP41DaBx0WLMx
	OBNTc5pdio6QwySmJopzQ==
Message-ID: <6599ad830803050241k590e4389ud95b9b3ef920f8b6@mail.gmail.com>
Date: Wed, 5 Mar 2008 02:41:41 -0800
From: "Paul Menage" <menage@google.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC] libcg: design and plans
Cc: fedora-devel-list@redhat.com, opensuse-packaging@opensuse.org,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>
In-Reply-To: <20080305103343.GA22217@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080304152341.GB5659@linux.vnet.ibm.com>
	 <6599ad830803042215n6aedb3eeub0c037e6a4e7bb34@mail.gmail.com>
	 <20080305103343.GA22217@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 2:33 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>
>  So there are two different points, /mem and /cpu. /mem has A and C and
>  /cpu has A, B and C. A and B of /cpu correspond to A of /mem and the C's
>  are the same. With this is mind, if I say a task should move to B in
>  /cpu, it should also move to A in /mem?
>

Maybe clearer to say that /mem has two cgroups, AB and C. The
abstraction provided by libcg would be of three groups, A, B and C.
Asking libcg to move a process to abstract group B would result it
moving to /mem/AB and /cpu/B

Paul
