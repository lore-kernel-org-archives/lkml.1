Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbYLDLe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbYLDLe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 06:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYLDLes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 06:34:48 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:40460 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbYLDLer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 06:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BaXEHK/2tc3n9pUscmdLNGKTui5uZ+sdKYEq2dVE9BXdsTnPAOK0N483OMUpZjiI+K
         viHDOHqbU2p4CGzKrpwCPHaOB/xHEby21l8N0fdnxBqA4ZPCocMtzJYIv4vDSlbV9vh0
         WduTNYy7IgFkavC6KEsPUIesD83uO3L9RBNWg=
Message-ID: <2375c9f90812040334x1abed8d9q98b74a3883fe0417@mail.gmail.com>
Date: Thu, 4 Dec 2008 11:34:46 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/3] fix warning of not used variable
Cc: "Jianjun Kong" <jianjun@zeuux.org>, rusty@rustcorp.com.au,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
In-Reply-To: <20081204101223.GB18708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081204010022.GB17445@ubuntu> <20081204101223.GB18708@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 10:12 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>
> NAK. Warnings do not need to be "fixed", then need to be looked at and
> then there are two approaches:
>
>  1) GCC is wrong => annotate the code
>  2) GCC is right => fix the code
>

Gcc is correct.

The only user of print_unload_info() is m_show() which is protected by
CONFIG_PROC_FS.
