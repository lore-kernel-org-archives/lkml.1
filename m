Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZCVIao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZCVIao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 04:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZCVIad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 04:30:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:33106 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZCVIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 04:30:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=cDXoaKXXONj8abOWiRElspD4SvXZiAynM/IWRqxawVoXZsCFfmBKY7cNhP4dHdhFyg
         9IZjkV2rg9Hyp4FdR7ES7d7Ljrpj6Rym2YdmBvhUsaC2TxoxT7vHdk90ovq0lF6plHwF
         c5o91vA4I2w1AtdUCF1Ur2eCfhaZmojwhgbxw=
Subject: [PATCH 0/4] tracing: event filtering v2
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 03:30:26 -0500
Message-Id: <1237710626.7703.45.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 2 of my patchset adding filtering to the event-tracing
infrastructure.

Changes from the previous version:

- added common_ prefix to the 5 common event fields
- ring_buffer_event_discard() fixes from Steven Rostedt
- changed 'and' and 'or' for compound filters to '&&' and '||'
- fixed a bug in the matching logic 

Everything seems to work ok for me, but I haven't yet gotten around to
changing the awkward UI.  I plan to fix that as soon as I can i.e. allow
complete compound expressions to be specified all at once, add <, >, <=,
>= and parens, etc.  Until then, it should hopefully be usable for basic
filtering. 

Thanks,

Tom

