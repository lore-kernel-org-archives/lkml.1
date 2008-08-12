Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbYHLVuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbYHLVuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYHLVtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:49:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:24828 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYHLVtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wteFMHHJtGpaLmMXQnueL87QZQyCyV+xuIoP1u6nQS+m5KLyUjdTS8bXO0q7mCLhFa
         YIJYYpdrOQ2CzfQgwVvJNo+xy7xv/iSwHHbwiel54s09Fz4MG3IT/9CM9gVThJQ3rDE+
         VXgjBvJvB60MpB15LRuDC4Mnr+Nr2WGz0eQEg=
Message-ID: <1ba2fa240808121449j4c04039bu2fc9b58129dc6027@mail.gmail.com>
Date: Wed, 13 Aug 2008 00:49:51 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: iwl + iomap + readl/writel
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48A1F734.7040801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A1F734.7040801@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 11:48 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Hi,
>
> I spotted that iwl drivers use readl method on an iomap space. IIRC some
> archs might return a tag instead of an address expected by readl/writel.
>
> I think you should either switch to ioread32/iowrite32 or to ioremap.

Can you give me reading material  on this?
Thanks
Tomas
