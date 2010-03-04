Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0CDBxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:53:11 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:64192 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab0CDBxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:53:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=f492gutvQz1i8DqoKqFpZN5LaHn+pcAvfXHmCl0N7vfgvEPKhiLbuqIRG9k+X3qdgg
         gFnDZX1iq6pvaI2/SUSkwwtoTOD9OmOeyyRuG8EMp3gi8arZI2HTPoyrThSSe0/aQpFH
         K8IybLlhxjxKMJKAAOPSAOtzcy5AWop0p9r80=
MIME-Version: 1.0
In-Reply-To: <413a6a951003030411y2c11c6eaj551c26e1bed3679d@mail.gmail.com>
References: <4B3F8896E1733D4787DDB0EA1C7FF91F01163E1D@ukmail.uk.wirelessworld.airvananet.com> 
	<413a6a951003030411y2c11c6eaj551c26e1bed3679d@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 3 Mar 2010 17:46:02 -0800
Message-ID: <a36005b51003031746g3b83bcf6w818601dc94f66c42@mail.gmail.com>
Subject: Re: do_loop_readv_writev() not as described for drivers implementing 
	only write()?
To: Daniel Baluta <daniel.baluta@gmail.com>
Cc: Mike McTernan <mmcternan@airvana.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 04:11, Daniel Baluta <daniel.baluta@gmail.com> wrote:
> I would say that the libc enforces atomicity,

Not at all.  Any such implementation would unconditionally have to use
file locking and that's only a convention, not a requirement.  The
libc only tries to work around a missing writev syscall.
