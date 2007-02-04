Return-Path: <linux-kernel-owner+w=401wt.eu-S1752283AbXBDMgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbXBDMgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 07:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXBDMgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 07:36:46 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:43720 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbXBDMgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 07:36:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b3w4tE3Eswv8gzhbRoX271CzyZZo+/mbysiK/gisLKcNzFaBnQf5dZRAe1WtHKIUBBzIj9zn1aIcmgT2YgPsgu3pMBtjnkl1wMBPv1BCyMSy4BDTD8HT07qDMKCbDeVIdN1Y84XqYy5ZlRPnrRIUiLsNWZrBYm1FFwCmHhhG9pQ=
Message-ID: <1a297b360702040436g1193ddfcscea68236f5b9092a@mail.gmail.com>
Date: Sun, 4 Feb 2007 16:36:44 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: A CodingStyle suggestion
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070203215848.GA10440@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070203215848.GA10440@Ahmed>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> Hi all,
>
> In CodingStyle Chapter 16 "Function return value and names", why not
> adding a comment about the favorable community way of checking the return
> value. ie:
>
> ret = do_method();
> if (ret) {
>    /* deal with error */
> }
>
> and not other ways like:
>
> if (do_method()) or if ((ret = do_method()) > value) ...


if we have some 100 lines of

ret = do_method()
if (ret) {
/* error handling */
}

This is going to additionally increase the number of lines of unnecessarily.

IMHO, when you have a large number of lines which do a similar thing ..

if ((ret = do_method()) < value)
   goto err;

could greatly reduce the number of lines, otherwise.

manu
