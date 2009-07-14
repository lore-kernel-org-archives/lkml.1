Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZGNNui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZGNNui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZGNNuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:50:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:33426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbZGNNuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:50:37 -0400
Subject: Re: [PATCH] AFS: Fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       akpm@linux-foundation.org, linux-afs@lists.infradead.org
In-Reply-To: <4131.1247577044@redhat.com>
References: <1247561931.2473.2.camel@ht.satnam>
	 <20090709094430.23882.46013.stgit@warthog.procyon.org.uk>
	 <1247561220.2473.0.camel@ht.satnam>  <4131.1247577044@redhat.com>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 19:19:42 +0530
Message-Id: <1247579382.11921.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 14:10 +0100, David Howells wrote:
> Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > 2. fix 80 column wrap problem
> 
> I don't see an 80-column wrap problem that you've removed.
> 

ok here it is :

-               if (fid.vnode != vnode->fid.vnode) {
-                       _debug("%s: dirent changed [%u != %u]",
-                              dentry->d_name.name, fid.vnode,
-                              vnode->fid.vnode);
-                       goto not_found;
-               }

+       if (fid.vnode != vnode->fid.vnode) {
+               _debug("%s: dirent changed [%u != %u]",
+                      dentry->d_name.name, fid.vnode, vnode->fid.vnode);
+               goto not_found;
+       }


-               /* if the vnode ID uniqifier has changed, then the file has
-                * been deleted and replaced, and the original vnode ID has
-                * been reused */

+       /*
+        * if the vnode ID uniqifier has changed, then the file has been
+        * deleted and replaced, and the original vnode ID has been reused
+        */

--
JSR

