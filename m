Return-Path: <linux-kernel-owner+w=401wt.eu-S1762217AbZJOQOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217AbZJOQOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZJOQOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:14:19 -0400
Received: from fifo99.com ([67.223.236.141]:55774 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbZJOQOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:14:19 -0400
Subject: Re: Tips for module_init() dependencies
From: Daniel Walker <dwalker@fifo99.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AD7469B.9070907@gmail.com>
References: <4AD71D12.9060203@gmail.com> <1255621559.22917.35.camel@desktop>
	 <4AD7469B.9070907@gmail.com>
Content-Type: text/plain
Date: Thu, 15 Oct 2009 09:12:09 -0700
Message-Id: <1255623129.22917.41.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 11:58 -0400, Gregory Haskins wrote:

> Hi Daniel,
> 
> Possibly.
> 
> A) Any suggestions on how? Can I express this in Kconfig or something
> (i.e. "depends on FOO").  I currently have "select FOO" in the BAR
> object, but this doesn't seem to be sufficient to describe the relationship.
> 
> B) Do I have to make the entire chain follow suit? (I have C deps on B,
> B deps on A kind of scenarios)

Yeah, what Randy said .. As far as I know it should be just a build
order issue .. In the make file when you specify your new module along
with all the others where you put it is actually important .. In
fs/Makefile you have this line,

obj-$(CONFIG_CONFIGFS_FS)       += configfs/

and I would guess you want yours after that line if your adding to that
makefile.

Daniel

