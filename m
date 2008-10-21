Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbYJUFvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbYJUFvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYJUFvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:51:05 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:53002 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYJUFvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:51:04 -0400
Message-ID: <48FD6DA1.5030402@kernel.org>
Date: Mon, 20 Oct 2008 22:50:25 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       viro@zeniv.linux.org.ok, sgrubb@redhat.com, serue@us.ibm.com
Subject: Re: [PATCH 1/4] CAPABILITIES: add cpu endian vfs caps structure
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com> <20081020222602.3895.77302.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081020222602.3895.77302.stgit@paris.rdu.redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Paris wrote:
> This patch add a generic cpu endian caps structure and enternally available
> functions which retrieve fcaps information from disk.  This information is
> necessary so fcaps information can be collected and recorded by the audit
> system.
> 
[...]
>  	CAP_FOR_EACH_U32(i) {
> -		__u32 value_cpu;
> -
> -		if (i >= tocopy) {
> -			/*
> -			 * Legacy capability sets have no upper bits
> -			 */
> -			bprm->cap_post_exec_permitted.cap[i] = 0;
> +		if (i > tocopy) {

Shouldn't the above still be (i >= tocopy) ?

Cheers

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI/W2e+bHCR3gb8jsRAtDBAJ94XoCVXRDDycns4KEmLLBlYODiqACfUD7W
wx996Hso7mGH9lcc8Eiq89k=
=gx3P
-----END PGP SIGNATURE-----
