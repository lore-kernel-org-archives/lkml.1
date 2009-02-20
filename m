Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbZBTUzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbZBTUzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 15:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZBTUzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 15:55:46 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:43759 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZBTUzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:55:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rv8MkAE7dXNU/uVfMRNNzdYdsfPi6g0M2wOURPFZmMx54CH8EYByTrn4FXhyilN+Ah
         dtpDV/ggqKlZ4mc3eqfTqoho2T4918CFP/L9oDjskcLE2Q6Yl50seQ9+ykZt65snc7Qp
         JjBgx/KydgFkcXvLdauPkBkgqchRThJH4BiLM=
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.0902202138421.3998@horst-reiterers-macbook-air.local>
References: <alpine.OSX.2.00.0902202138421.3998@horst-reiterers-macbook-air.local>
Date: Fri, 20 Feb 2009 14:55:44 -0600
Message-ID: <524f69650902201255j60d3074fkc458987c5fc56e9d@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs: send SMB_COM_FLUSH in cifs_fsync
From: Steve French <smfrench@gmail.com>
To: Horst Reiterer <horst.reiterer@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 2:51 PM, Horst Reiterer
<horst.reiterer@gmail.com> wrote:
> Hi,
>
> In contrast to the now-obsolete smbfs, cifs does not send SMB_COM_FLUSH
> in response to an explicit fsync(2) to guarantee that all volatile data
> is written to stable storage on the server side, provided the server
> honors the request (which, to my knowledge, is true for Windows and
> Samba with 'strict sync' enabled).
> This patch modifies the cifs_fsync implementation to restore the

Patch seems reasonable at first glance.  Will take a look in more
detail this weekend.



-- 
Thanks,

Steve
