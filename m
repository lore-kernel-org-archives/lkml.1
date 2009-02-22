Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZBVVDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZBVVDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZBVVDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:03:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:46588 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbZBVVDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NlwrF2iPxN0wweFCysduzW+/iDtmFyd567P5fIug0e32QMcve+ULNQJpUiZQGo9fs0
         kfD6gJlnzBGjNiLoqgMKrHmuFaBZdEPqY81lnuMuZo+h0U3VThVSEWb+0eaHmOCIW52S
         2/ugdMg3HmWbD65UhsR+l7CTI/6M+a+ycWShw=
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.0902222137080.7676@horst-reiterers-macbook-air.local>
References: <alpine.OSX.2.00.0902202138421.3998@horst-reiterers-macbook-air.local>
	 <524f69650902201721l1c7f0d34p4708980a90d7fc8f@mail.gmail.com>
	 <alpine.OSX.2.00.0902222137080.7676@horst-reiterers-macbook-air.local>
Date: Sun, 22 Feb 2009 15:03:32 -0600
Message-ID: <524f69650902221303h37feb366k3d89a07bfd100ea3@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs: send SMB_COM_FLUSH in cifs_fsync
From: Steve French <smfrench@gmail.com>
To: Horst Reiterer <horst.reiterer@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 2:50 PM, Horst Reiterer
<horst.reiterer@gmail.com> wrote:
> In any case, it's probably a good idea to introduce a mount option. The
> new behavior should be enabled by default though, to provide maximum data
> consistency.

Suggestions on what to call such a new mount option?  How about
"nostrictfsync"  ?

-- 
Thanks,

Steve
