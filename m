Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZAMFbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZAMFbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZAMFbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:31:41 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:3960 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZAMFbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:31:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PxyLuLXYVKoVi7QCTinMbRMg6mPXxWxh0dG3MhE4dNBc6B9cxJfDyRMgLl/VvAVSBC
         Zm3hBQdVPVMeW3PTHTCM4ne1hn7iJA2VLEuNlBJ5+MvbGnVdLK9YHG2L5h2rWPfwwUje
         Sqrid3O7zQs0kbqTVwy5bdSeSHP6+KzeHbgZc=
Subject: Re: pull request: wireless-2.6 2009-01-12
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090112.212345.259792227.davem@davemloft.net>
References: <20090112201302.GB3786@tuxdriver.com>
	 <20090112.212345.259792227.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 21:31:17 -0800
Message-Id: <1231824677.5405.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 21:23 -0800, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Mon, 12 Jan 2009 15:13:02 -0500
> 
> > Please let me know if there are problems!
> 
> There's something funny in this tree.   In changeset
> 19f0a391bf9d88307e52557ff3125b24e2519bd4 there is
> a removal of arch/arm/mach-integrator/clock.h
> 
> I think when you installed that commit something
> automatically deleted zero length files it found,
> but that's just a guess.

make clean will assume empty files should be deleted.

Harvey

