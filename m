Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbYHHKcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbYHHKcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:32:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYHHKby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:31:54 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:46175 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751245AbYHHKbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:31:53 -0400
To: linux-kernel@vger.kernel.org
Subject: Radical idea? Remove all automatic privilege escalation base on executable file attributes!
From: Markku Savela <msa@moth.iki.fi>
Date: Fri, 08 Aug 2008 13:31:51 +0300
Message-ID: <87abfn94rs.fsf@burp.tkv.asdf.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


That is, remove

 - setuid/setgid feature from Linux

 - cancel the capability attributes in files (or only only allow
   downgrading of capabilities)

(e.g. mount everything as nosuid or something, but eventually, the
code could be removed from the kernel)

The only way to escalate privileges would be to request starting of
the executable by some daemon (like upstart), which would grant or
deny the request based totally on some user space policies.

If granted,

 - would fork
 - child would setup the specified credentials to self
 - execve (or equivalent)

