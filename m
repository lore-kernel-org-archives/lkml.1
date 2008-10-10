Return-Path: <linux-kernel-owner+w=401wt.eu-S1760467AbYJJXIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760467AbYJJXIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 19:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYJJXI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 19:08:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:16869 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYJJXI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 19:08:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G7Fg6CgLFm0C1i0TXRvRcK+q+Nq2hDz5wFhygl5tMaKUyyWTvY2bqYrvRFSCGuI7tg
         52p6P8aOHYTwA3gBFlt4mksUWmXCVwjROeNJO8BuVWbgpxumrJYN3quopyt2O+4TAGG1
         IsHryCFsNXZa2OppPNxqWWX9J0xzaEdbRw09U=
Message-ID: <8bd0f97a0810101608r65fff53bi916510e47eda2a12@mail.gmail.com>
Date: Fri, 10 Oct 2008 19:08:27 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "David Rowe" <david@rowetel.com>
Subject: Re: [PATCH 16/23] Staging: add echo cancelation module
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       "Tzafrir Cohen" <tzafrir.cohen@xorcom.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <1223678567-30143-16-git-send-email-greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010224130.GA30117@kroah.com>
	 <1223678567-30143-16-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 18:42, Greg KH wrote:
> +#ifdef __BLACKFIN_ASM__

shouldnt this be CONFIG_BLACKFIN or just __bfin__ ?  unless i missed
some magic, that define doesnt get defined anywhere ...
-mike
