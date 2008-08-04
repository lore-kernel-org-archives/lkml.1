Return-Path: <linux-kernel-owner+w=401wt.eu-S1760893AbYHDGu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893AbYHDGu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 02:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYHDGun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 02:50:43 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:48537 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761298AbYHDGum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 02:50:42 -0400
Message-ID: <51633.166.70.238.45.1217831416.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:30:16 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 5/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/debug/mdb-base.h	1969-12-31 17:00:00.000000000 -0700
+++ b/debug/mdb-base.h	2008-08-03 16:15:00.000000000 -0600
@@ -0,0 +1,289 @@
+
+/***************************************************************************
+*
+*   Copyright (c) 2008 Jeff V. Merkey  All Rights Reserved.
+*   1058 East 50 South
+*   Lindon, Utah 84042
+*   jmerkey@wolfmountaingroup.com
+*
+*   This program is free software; you can redistribute it and/or modify it
+*   under the terms of the GNU General Public License as published by the
+*   Free Software Foundation, version 3.
+*
+*   This program is distributed in the hope that it will be useful, but
+*   WITHOUT ANY WARRANTY; without even the implied warranty of
+*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+*   General Public License for more details.
+*
+*   You are free to modify and re-distribute this program in accordance
+*   with the terms specified in the GNU Public License.  The copyright
+*   contained in this code is required to be present in any derivative
+*   works and you are required to provide the source code for this
+*   program as part of any commercial or non-commercial distribution.
+*   You are required to respect the rights of the Copyright holders
+*   named within this code.
+*
+*   jmerkey@wolfmountaingroup.com is the official maintainer of
+*   this code.  You are encouraged to report any bugs, problems, fixes,
+*   suggestions, and comments about this software.
+*
+*   AUTHOR   :  Jeff V. Merkey
+*   FILE     :  MDB-BASE.H
+*   DESCRIP  :  Merkey's NetWare Debugger
+*   DATE     :  April 8, 2008
+*
+***************************************************************************/
+
+#ifndef _MDB_BASE_H
+#define _MDB_BASE_H
+
+extern ULONG enterKeyACC(ULONG key, void *stackFrame,
+		     ACCELERATOR *accel);
+extern ULONG activateRegisterDisplayACC(ULONG key, void *stackFrame,
+		     ACCELERATOR *accel);
+
+extern ULONG displayDebuggerHelpHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG displayDebuggerHelp(BYTE *commandLine,
+			 StackFrame *stackFrame, ULONG Exception,
+			 DEBUGGER_PARSER *parser);
+
+extern ULONG ascTableHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displayASCTable(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser);
+
+extern ULONG displayToggleHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ProcessTUToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG ProcessTDToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG ProcessTLToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG ProcessTGToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG ProcessTCToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG ProcessTNToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG ProcessTRToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG ProcessTSToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+extern ULONG ProcessTAToggle(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+
+extern ULONG displayDebuggerVersionHelp(BYTE *commandLine,
DEBUGGER_PARSER *parser);
+extern ULONG DisplayDebuggerVersion(BYTE *cmd,
+		   StackFrame *stackFrame, ULONG Exception,
+		   DEBUGGER_PARSER *parser);
+
+extern ULONG displayKernelProcessHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG displayKernelProcess(BYTE *cmd,
+			  StackFrame *stackFrame, ULONG Exception,
+			  DEBUGGER_PARSER *parser);
+
+extern ULONG displayKernelQueueHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG displayKernelQueue(BYTE *cmd,
+			StackFrame *stackFrame, ULONG Exception,
+			DEBUGGER_PARSER *parser);
+
+extern ULONG displaySymbolsHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displaySymbols(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser);
+
+extern ULONG displayLoaderMapHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG displayLoaderMap(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser);
+
+extern ULONG displayModuleHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displayModuleInfo(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern ULONG displayProcessesHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG displayProcesses(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser);
+
+extern ULONG displayRegistersHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG displayControlRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser);
+extern ULONG displayAllRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser);
+extern ULONG displaySegmentRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser);
+extern ULONG displayNumericRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser);
+extern ULONG displayGeneralRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser);
+extern ULONG displayDefaultRegisters(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser);
+
+extern ULONG displayAPICHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displayAPICInfo(BYTE *cmd,
+		     StackFrame *stackFrame, ULONG Exception,
+		     DEBUGGER_PARSER *parser);
+
+extern ULONG listProcessors(BYTE *cmd,
+		    StackFrame *stackFrame, ULONG Exception,
+		    DEBUGGER_PARSER *parser);
+extern ULONG listProcessorFrame(BYTE *cmd,
+			StackFrame *stackFrame, ULONG Exception,
+			DEBUGGER_PARSER *parser);
+
+extern ULONG ReasonHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG ReasonDisplay(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+
+extern ULONG displayMPSHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displayMPS(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+
+extern ULONG clearScreenHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG clearDebuggerScreen(BYTE *cmd,
+			 StackFrame *stackFrame, ULONG Exception,
+			 DEBUGGER_PARSER *parser);
+
+
+extern ULONG SearchMemoryHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG SearchMemory(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+extern ULONG SearchMemoryB(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+extern ULONG SearchMemoryW(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+extern ULONG SearchMemoryD(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+
+extern ULONG changeMemoryHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG changeWordValue(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+extern ULONG changeDoubleValue(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+extern ULONG changeByteValue(BYTE *cmd,
+	       StackFrame *stackFrame, ULONG Exception,
+	       DEBUGGER_PARSER *parser);
+extern ULONG changeDefaultValue(BYTE *cmd,
+			StackFrame *stackFrame, ULONG Exception,
+			DEBUGGER_PARSER *parser);
+
+
+extern ULONG displayCloseHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displayCloseSymbols(BYTE *cmd,
+			 StackFrame *stackFrame, ULONG Exception,
+			 DEBUGGER_PARSER *parser);
+
+
+extern ULONG displayINTRHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displayInterruptTable(BYTE *cmd,
+			   StackFrame *stackFrame, ULONG Exception,
+			   DEBUGGER_PARSER *parser);
+
+
+extern ULONG viewScreensHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displayScreenList(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+
+extern ULONG displayIOAPICHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG displayIOAPICInfo(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+
+
+extern ULONG displayDumpHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG debuggerWalkStack(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+extern ULONG debuggerDumpLinkedList(BYTE *cmd,
+			    StackFrame *stackFrame, ULONG Exception,
+			    DEBUGGER_PARSER *parser);
+extern ULONG debuggerDumpWord(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser);
+extern ULONG debuggerDumpStack(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+extern ULONG debuggerDumpDoubleStack(BYTE *cmd,
+			     StackFrame *stackFrame, ULONG Exception,
+			     DEBUGGER_PARSER *parser);
+extern ULONG debuggerDumpDouble(BYTE *cmd,
+			StackFrame *stackFrame, ULONG Exception,
+			DEBUGGER_PARSER *parser);
+extern ULONG debuggerDumpByte(BYTE *cmd,
+		      StackFrame *stackFrame, ULONG Exception,
+		      DEBUGGER_PARSER *parser);
+
+
+extern ULONG displayDisassembleHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG processDisassemble16(BYTE *cmd,
+			  StackFrame *stackFrame, ULONG Exception,
+			  DEBUGGER_PARSER *parser);
+extern ULONG processDisassemble32(BYTE *cmd,
+			  StackFrame *stackFrame, ULONG Exception,
+			  DEBUGGER_PARSER *parser);
+
+extern ULONG rebootSystemHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG rebootSystem(BYTE *cmd, StackFrame *stackFrame, ULONG
Exception,
+	                  DEBUGGER_PARSER *parser);
+
+extern ULONG displaySectionsHelp(BYTE *commandLine, DEBUGGER_PARSER
*parser);
+extern ULONG displaySections(BYTE *cmd,
+		             StackFrame *stackFrame, ULONG Exception,
+		             DEBUGGER_PARSER *parser);
+extern ULONG displayKernelProcessHelp(BYTE *commandLine,
+                                      DEBUGGER_PARSER *parser);
+extern ULONG displayKernelProcess(BYTE *cmd,
+		                  StackFrame *stackFrame, ULONG Exception,
+		                  DEBUGGER_PARSER *parser);
+extern ULONG displayProcessorStatusHelp(BYTE *commandLine,
+                                        DEBUGGER_PARSER *parser);
+extern ULONG displayProcessorStatus(BYTE *cmd,
+		       StackFrame *stackFrame, ULONG Exception,
+		       DEBUGGER_PARSER *parser);
+
+extern ULONG backTraceHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG backTraceAllPID(BYTE *cmd, StackFrame *stackFrame,
+                             ULONG Exception, DEBUGGER_PARSER *parser);
+extern ULONG backTracePID(BYTE *cmd, StackFrame *stackFrame,
+                             ULONG Exception, DEBUGGER_PARSER *parser);
+extern ULONG backTraceStack(BYTE *cmd, StackFrame *stackFrame,
+                             ULONG Exception, DEBUGGER_PARSER *parser);
+
+#if defined(CONFIG_MODULES)
+extern ULONG listModulesHelp(BYTE *commandLine, DEBUGGER_PARSER *parser);
+extern ULONG listModules(BYTE *cmd, StackFrame *stackFrame, ULONG Exception,
+	                 DEBUGGER_PARSER *parser);
+extern ULONG unloadModule(BYTE *cmd, StackFrame *stackFrame, ULONG
Exception,
+	                 DEBUGGER_PARSER *parser);
+#endif
+
+#endif
+


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



