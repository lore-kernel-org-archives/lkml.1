Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487Ab0ASOYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0ASOYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368Ab0ASOX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:23:58 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:65068 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0ASOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:23:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r448a/75bSJE1497Nyc7ZIws5s7C5mJy6CFIF8vB2SA4mlCNnHIN0UrP/9r9DgGuli
         +AHaW6KdlfinknJbalUzFxIi5Y4YgWt92ETyGBMyCcea3DNr70euJUvUNWCZSZ8k9fgi
         sQ77T2X6RPInsGYIURMYMF3cBK58dRB2TxEaY=
Date: Tue, 19 Jan 2010 22:25:45 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: dont hardcode path to lsmod
Message-ID: <20100119142545.GB3473@hack>
References: <1263883920-17289-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263883920-17289-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 01:52:00AM -0500, Mike Frysinger wrote:
>The lsmod utility has always been installed into /bin with the newer
>module-init-tools package, so let lsmod be found via PATH instead of
>hardcoding the old modutils /sbin path.
>

Some distro doesn't set /sbin to PATH, so for me a better solution
would be making PATH contain /sbin, and then use "lsmod".

Thanks.

-- 
Live like a child, think like the god.
 
