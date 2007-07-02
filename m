Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbXGBTG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbXGBTG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXGBTGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:06:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:58826 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbXGBTGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hXk2aq3Jc/o8ySnSK5/8XCpabXx5SXhsiwXVw9uwrPTUqUv/bVpMrGBITjpyiQWmkXlLZH4oBO/cz+72luKKWJCvcCgYQJVFOyAgAstYWDVj7n42XXahyqrBDCp/iPTpmk6hUE0bwzgufr52aoVvbf8vGbVxxKV3I68gBfaDABU=
Message-ID: <a36005b50707021206t417d69ddqcaa8d140e24fa3e3@mail.gmail.com>
Date: Mon, 2 Jul 2007 12:06:45 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer madness
Cc: "Andy Isaacson" <adi@hexapodia.org>, "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46894BE6.1040302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.5792.1183056564.0>
	 <20070629193954.GL9157@hexapodia.org>
	 <Pine.LNX.4.64.0706291306220.31176@alien.or.mcafeemobile.com>
	 <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com>
	 <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>
	 <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com>
	 <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com>
	 <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com>
	 <20070702190043.GN9157@hexapodia.org> <46894BE6.1040302@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Rik van Riel <riel@redhat.com> wrote:
> That should not happen.  The default SELinux configuration
> in Fedora (and Debian?) runs a few daemons in their own
> restricted modes and has most of the system running in
> unconfined_t, including the majority of user programs.

This is the state as of F7.  This will change hopefully soon.
Programs like firefox run by normal users must be confined, to. Any
tests using security must be fast, it's not something which is done
only for a few apps.
