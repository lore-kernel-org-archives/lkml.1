Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbXJBXDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbXJBXDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXJBXD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:03:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:46136 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbXJBXD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TDaw21kgO1sPDHHEHiv6Ga+8KU97CylTtAQ3xmF9Tz/WJDobHsBmBO9Y6YA7OkhdQ+5DIHUlsIrdWfKk9G/sgKimH6I+emvSnSFoW8LSUbmRgxDKQv3K4C1Aef3f2lLMYW/peYRQ2S+3qqWYPVw7oBDJU+MxKLzZfZCt4oM1ycw=
Message-ID: <3d8471ca0710021603x2288fbe9h78e3568235140d7c@mail.gmail.com>
Date: Wed, 3 Oct 2007 01:03:26 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Andrew Morton" <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Handle errors in sync_sb_inodes()
In-Reply-To: <20071003005706.0fbacb94@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071003005706.0fbacb94@localhost.localdomain>
X-Google-Sender-Auth: 84e07e707ddb6d93
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +               mapping_set_error(mapping, ret);

And of course, s/ret/err/ :-(

-- 
Guillaume
