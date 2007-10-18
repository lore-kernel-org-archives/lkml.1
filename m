Return-Path: <linux-kernel-owner+w=401wt.eu-S1765538AbXJROiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765538AbXJROiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbXJROh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:37:59 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:21826 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbXJROh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K+p0crwu25Lo5nQ+Vx9UiDBUeXrd1nP2ysamBSrKp35f640sMAbuK57+l5yGDxILbvYh/m4/REDoESQ+i5G35tQYHe+i1sXtTTZJeJZAd76vb1QQj83kJFuxwesal5xRdGXZVVfjmna078X4y/Box3t2n6fSWtlL0gk+RdwIttk=
Message-ID: <d120d5000710180737yeba5445tdb3b302ed6f7a802@mail.gmail.com>
Date: Thu, 18 Oct 2007 10:37:55 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeremy Katz" <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <20071017204250.GA13377@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071016144016.GA21749@srcf.ucam.org>
	 <20071016184606.GB25181@srcf.ucam.org>
	 <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org>
	 <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
	 <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org>
	 <d120d5000710170857i3f534544pe9cab0ca6c1b0aa4@mail.gmail.com>
	 <20071017162827.GA9778@srcf.ucam.org>
	 <20071017173532.GB2974@khazad-dum.debian.net>
	 <d120d5000710171159p617115d9w862aadf266c2470c@mail.gmail.com>
	 <20071017204250.GA13377@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> Still, I was
> thinking about it, and a doubt came to mind: would it cause problems for a
> bitmap to share the function for EV_foo and EV_foo notifications?
>

Not sure if I follow... Are you talking about bringing KEY_*_NOTIFY
into EV_KEY "namespace"? Could you elaborate?

-- 
Dmitry
