Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbYFKFyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbYFKFyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 01:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYFKFxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 01:53:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:29549 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYFKFxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 01:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DeUxAoANNWidtNbXBc5sWAnqIEuygdkTF3xcqd6tRihOVwdvfLy5v51kemICC6m//s
         2jIIy7Oej6qVS6/CzXGn7HLWhInpbDCRemPxlJdZr7aVYVrGo1y1G+jxl85Sn4T5Gc6g
         ZJE4IlAmAJNTJbX762em1KiIa30X2z2/qoplY=
Message-ID: <863e9df20806102253p4161e5bfv96ecc8ac5b4f9a89@mail.gmail.com>
Date: Wed, 11 Jun 2008 11:23:54 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: ananth@in.ibm.com
Subject: Re: [PATCH] kprobes: remove redundant config check
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Masami Hiramatsu" <mhiramat@redhat.com>, akpm@linux-foundation.org
In-Reply-To: <20080611035955.GA19154@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484EB61E.7050509@gmail.com> <20080611035955.GA19154@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/08, Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> Abhishek,
>
>  This was intentional (to take care of some gcc 4.2 issues). See commit
>  cd5bfea278987ebfe60f3ff92a01696b17c4f978 (fix compilation with gcc 4.2)
>  from Peter Chubb for details.

Yea, I checked it out and the problem the commit seems to be fixing is that
EXPORT_SYMBOL  complains for static symbols with gcc-4.2. Can't see why
there was a need to cram CONFIG_KPROBES inside kprobes.c. This
check was sneaked in defensively it seems, and is unnecessary.

--
Regards,
Abhishek Sagar
