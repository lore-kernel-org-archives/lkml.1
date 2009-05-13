Return-Path: <linux-kernel-owner+w=401wt.eu-S1761863AbZEMVyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761863AbZEMVyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 17:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZEMVyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 17:54:35 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63859 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZEMVyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 17:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S68knBpUiKaIz2KtkK36O96jyuUASHyYBM3Qv90Iazuqr3AyIF1PK+L7Y4rqKidh3r
         r9TcDtJOC7v9jvbvHiB1LBVOzDPc9b9uaDoo5bLpkLlqX3kReED9OnyMhksttQVKrPOp
         j55kv289GFjpz+NS83A1+hNyyHk4Q0RHyStTs=
MIME-Version: 1.0
In-Reply-To: <a4423d670905121449p3f1112d3rf2e4a1e57cd076e@mail.gmail.com>
References: <f74141980905121422p140d1649jcfb3d94aacd42f02@mail.gmail.com>
	 <a4423d670905121449p3f1112d3rf2e4a1e57cd076e@mail.gmail.com>
Date: Thu, 14 May 2009 01:54:34 +0400
Message-ID: <f74141980905131454r725b2daft49074194087efe1f@mail.gmail.com>
Subject: Re: jsm: two or more 4/8-port boards can not initialize ports 
	properly
From: "Alexander Y. Fomichev" <git.user@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 1:49 AM, Alexander Beregalov
<a.beregalov@gmail.com> wrote:
> 2009/5/13 Alexander Y. Fomichev <git.user@gmail.com>:
>> G' day
>>
>> The patch bellow fix for me problem with jsm_uart_port_init
>> which still thinking it works for 2-ports borads only.
>> drivers/serial/jsm/jsm_tty.c +462
>> brd->channels[i]->uart_port.line = brd->channels[i]->ch_portnum +
>> brd->boardnum * 2;
>>
>>                         ^^^^^^^^^^^^^^^^^^^^^^
>> so for line numbers of the second and further boards
>> may/will be assigned values with the same range.
>> in my case of two digi neo-8 -- 6 ports of 8 failed to be
>> added for the second board.
>
> Hi Alexander,
>
> Your patch is broken, your mail client wraps long lines.
> Please read Documentation/email-clients.txt.
> Please add linux-serial@vger.kernel.org,
> alan@lxorguk.ukuu.org.uk and Scott.Kilau@digi.com to CC list.
> Please add Signed-off-by line as described in Documentation/SubmittingPatches

tnx for advise



-- 
Best regards.
       Alexander Y. Fomichev <git.user@gmail.com>
