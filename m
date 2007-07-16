Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbXGPKWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbXGPKWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXGPKWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:22:14 -0400
Received: from web26904.mail.ukl.yahoo.com ([217.146.176.93]:24969 "HELO
	web26904.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752745AbXGPKWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:22:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=XlAdtNH5fEIMSm2njKZZqlfH12Iu1kMDYre75riau+Yck8W74R6sOBV/9XxczjvhGJAA5iW/+1r1NFU+FWnCTROJHTSF048N21NkWJFtESIkQ/wPshyFDIoh4+nLwBq5xfFgHXn/nS6yCvdbQZJXd1WJ570ISUkR7hmrb5KrNE8=;
X-YMail-OSG: 8YwIfZUVM1nXbnqVuXDDbUDc4ruONm9_gjd04ApdVCMqm40e_biTrgFklO.wgGCISUBQXJ_EzzQMt2fNppKPuOCS
Date: Mon, 16 Jul 2007 12:21:52 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: x86 setup code rewrite in C - revised
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <469B3714.80105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <17027.55623.qm@web26904.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- "H. Peter Anvin" <hpa@zytor.com> wrote:
> Etienne Lorrain wrote:
> >   "mov %fs:(%ebx,%eax,4),%ecx" works for me.
> 
> That's an example on what "m" can generate.
> 
> "g" could produce stuff like:
> 
> 	mov %fs:$1234,%ecx
> 	mov %fs:%eax,%ecx

 My solution was to use %fs:%a1 instead of %fs:%1 , but after checking your
solution produces better assembly.

 Etienne.


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
