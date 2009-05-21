Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbZEUNIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbZEUNIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZEUNI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:08:28 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35926 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZEUNI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gK1GiE0ERHwo2G8VqNyXU42uTrKY6+0JkAlpQT3kdDQs6BBy4OxmKLoy5etVDF4NX1
         MdNIR37wKH7JGmAaEoHMnkNiK9E2mHtJIzKYGdaQnvVSPc+oWMQB8KwcT25KwC5E9JLM
         +QDXEWpfU4+XpoAC6m+r7WZ4Ytq92+FiSAqrE=
MIME-Version: 1.0
In-Reply-To: <20090513132342.GA16280@orion>
References: <1242219648-16165-1-git-send-email-a.beregalov@gmail.com>
	 <1242219648-16165-2-git-send-email-a.beregalov@gmail.com>
	 <20090513132342.GA16280@orion>
Date: Thu, 21 May 2009 17:08:28 +0400
Message-ID: <a4423d670905210608k25a92253j21fc231dd467bff2@mail.gmail.com>
Subject: Re: [PATCH 2/2] Staging: comedi: data.c should include delay.h
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/13 Alexander Beregalov <a.beregalov@gmail.com>:
> Fix this build error:
> .../data.c:86: error: implicit declaration of function 'udelay'
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---

Greg,
Please apply instead my another patch, which includes delay.h in comedidev.h.
