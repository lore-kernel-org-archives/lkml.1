Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbYJaSdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbYJaSdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYJaSdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:33:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:26419 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYJaSdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:33:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eKPAzBgW5QC6tb6aWws9hGCtmJxHcMlLkx9gEHWxNs79GY1cAzeE6FV1c47FImYPk/
         pAUhb+RFD5aloz8Od9Fqf/Db5iySl+oZxWBSNfeSVKHPZQETyklgeAuunTXYBgiHShik
         6/fDDVYfwJ8o847JZWX3tPUtLFopGVl0qOJew=
Message-ID: <40f31dec0810311133v65001e59h28cf6946ac3f14e7@mail.gmail.com>
Date: Fri, 31 Oct 2008 20:33:43 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: ath5k gets lost with eeepc-laptop removal
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       willy@linux.intel.com, lrodriguez@atheros.com
In-Reply-To: <20081031151901.2d68c32d@doriath.conectiva>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031110502.18e33eba@doriath.conectiva>
	 <40f31dec0810310926p6edd0af5o24d7616eb54c6d0@mail.gmail.com>
	 <20081031151901.2d68c32d@doriath.conectiva>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/31 Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>:
>
>  No, it doesn't. It says:
>
> """
> MAC revision 0xffff is not supported!
> """
>
>  And I have realized that I get a flood of 'failed to wakeup'
> and 'can't reset the hardware' error messages, just some seconds
> after the eeepc-laptop module removal.
>

Well it seems that during module removal, card gets no power at all.
I don't see any reason for this behaviour. Do you have pci-e hotplug enabled ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
