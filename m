Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZJKDhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZJKDhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 23:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZJKDhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 23:37:03 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:58692 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbZJKDhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 23:37:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Uvp5h1AvcbdkAb/ClR6nxteZpI3p2INPv8Pwoh5ZYrHj11wVUqwwc+3CVwJYEdtBgz
         iSOY4HjNBXzuptiLY+oCZB10OWD8H1OnYk+ptlLFLcc/3j3imUemzDujjGTzZwIjUtlK
         DlzFKkOjpnV/PjONDqIj8lL8TYe6ast8bi8W4=
MIME-Version: 1.0
Date: Sat, 10 Oct 2009 20:36:25 -0700
Message-ID: <9ff7a3bc0910102036u6e912817hd335d41a5976f30b@mail.gmail.com>
Subject: tasklets and queuing.
From: Joel Fernandes <agnel.joel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Friends,

I have a question about tasklets:

I understand that they are used to defer work during interrupt
handling. What I don't understand is - how do they handle queuing of
deferred work?
Specially with tasklets, if a tasklet is re-scheduled before the
previous scheduling of the same tasklet has a chance to run, then the
tasklet is executed only once - not twice. But what if the work that
the tasklet was supposed to do in these 2 instances were different and
that its function was supposed to be passed 2 different structures?
Shouldn't the tasklet be executed twice with these 2 structures?

I know that work queues are there for that, but how do device drivers
that use tasklets cope with the above?

Thanks,
-Joel
