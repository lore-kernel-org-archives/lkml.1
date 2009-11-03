Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbZKCRbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbZKCRbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZKCRby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:31:54 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:52713 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbZKCRbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:31:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uaNeI3i6vPvSY55hZ9g7YI6I+T3RVQS9kFPVmesdVi20EuzM/fQV0Av65IIUVwMOS5
         RPxo8gScRK5Y79H2F8ZS+QQtHxrbOGd1KymIYsnreZWk3dEocJLTBGjxUZBn+aEqdo+q
         kT8m+wL/pFNYyXNAxaqd3R3GgtEtrqCd/fMt4=
MIME-Version: 1.0
In-Reply-To: <20091103003511.GL7768@obsidianresearch.com>
References: <20091103003511.GL7768@obsidianresearch.com>
Date: Tue, 3 Nov 2009 09:31:55 -0800
Message-ID: <da7b3ce30911030931u1ccbff69ted4206606475c83@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable 
	multiple times
From: Hal Finney <hal.finney@gmail.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What if you don't want it accessible by user mode apps, you only want
your middleware (ie tcs daemon, tcsd) to open it? Will this still
allow that to be enforced, so nobody can interfere with tcsd's
exclusive access to the device?

Hal Finney
