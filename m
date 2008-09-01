Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbYIAMse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbYIAMse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 08:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYIAMs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 08:48:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:17687 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYIAMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 08:48:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JaO5HFx6P/8yjJwKUTBbJho0kI4UQZpsZGgE43dJNYtC72zAY4Y+Mx6aa2cByvbR6e
         vfQj09sCX7iT8WsnEq229fkKomSHwlpxaC3S8gytH12ovTdGLy4BXUU3v8k7an69fxV4
         GUH84CxZQk2Q5TB8LdozbFiImNUd9ho6bAYjM=
Message-ID: <d6c8ef150809010548q6b52992bod8224c7222b5aa84@mail.gmail.com>
Date: Mon, 1 Sep 2008 14:48:25 +0200
From: "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: GRE keepalive support
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After a few hours of googling I realized that there is no support for
GRE keepalives in Linux. Or, better to say, GRE keepalives are Cisco's
"proprietary" feature.

The project I'm currently working for needs GRE keepalives on Linux
side (besides possibility to run some routing protocol over GRE) in
order to have "link/tunnel state" information. It looks implementing that
feature on Linux is not too complicated and I'll give a try. Are there
any obstacles I'm currently unable to see? Maybe there is a reason why
GRE keepalives are not implemented? Except lack of detailed
documentation :)

So, any comments are welcome.

Thanks!
