Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbYLBKAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbYLBKAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYLBKAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:00:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:24273 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYLBKAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:sender;
        b=jISJSwvSBIvMOTODIGXaEUzs7SQpA/o9de8eNYl5G4bl7rFfQgPr5sWy+xuMSPikId
         XYJocb9iHSyF1+9SpUbuwygJEztIZJ4L6RGU52Dbx6Hbt982jYLlUn6494vnRMHLQo+H
         hKYhTJR1Ev+S/WhG5qtvWM3aDX9CXxQ8ljnz0=
Date: Tue, 2 Dec 2008 12:00:17 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Tom Zanussi <tzanussi@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [ANNOUNCE] kmemtrace userspace update
Message-ID: <20081202100016.GA5226@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I've patched kmemtrace to address Pekka's concerns. Here's the shortlog:

Eduard - Gabriel Munteanu (8):
      addr2line support
      Add private data pointer argument to hashtable actions.
      Add stats to hashtable implementation.
      Hashtable to vector conversion functions.
      kmemtrace-report: Sort call-site view by fragmentation.
      kmemtrace-report: addr2line support and output sorting for allocation view.
      kmemtrace-report: pretty formatting.
      Add debugging stats to hashtable.

http://repo.or.cz/w/kmemtrace-user.git

The improvements are in terms of usability.

The next thing on my list is integrating Tom's UTT patch and switching
to variable length packets (Mathieu's idea was we should encode field
sizes in a header and forego using the same pointer size on all arches).
Both would entail updating the kernel as well.

Feedback is much appreciated.


	Cheers,
	Eduard

